﻿Перем мИмяСлужбыСобственногоАгента;

Процедура КнопкаВыполнитьНажатие(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура Применить(Кнопка)
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат;
	КонецЕсли; 
	ПрименитьИзменения();
	ОбновитьДанные();
	
КонецПроцедуры

Процедура КомпьютерПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ОбновитьДанные();
	
КонецПроцедуры

Процедура КомпьютерНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыОбновить(Кнопка)
	
	Если Не ЗапроситьПодтверждение() Тогда
		Возврат;
	КонецЕсли; 
	ОбновитьДанные();

КонецПроцедуры

Процедура ОбновитьДанные()
	
	Заполнить();
	ОтборСтрок = Новый Структура("Сервер", Истина);
	СтрокиСборок = СборкиПлатформы.НайтиСтроки(ОтборСтрок);
	СписокРелизов = Новый СписокЗначений;
	Для Каждого СтрокаСборки Из СтрокиСборок Цикл
		Если СписокРелизов.НайтиПоЗначению(СтрокаСборки.СборкаПлатформы) = Неопределено Тогда
			СписокРелизов.Добавить(СтрокаСборки.СборкаПлатформы);
		КонецЕсли; 
	КонецЦикла;
	ЭлементыФормы.СлужбыАгентовСерверов1С.Колонки.СборкаПлатформыНовая.ЭлементУправления.СписокВыбора = СписокРелизов;
	ЭтаФорма.Модифицированность = Ложь;
	
КонецПроцедуры

Функция ЗапроситьПодтверждение()
	
	Результат = Истина;
	Если Модифицированность Тогда
		Ответ = Вопрос("Вы не применили изменения. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Результат = Ответ = КодВозвратаДиалога.ОК;
	КонецЕсли; 
	Возврат Результат;

КонецФункции

Процедура ДействияФормыПерезапустить(Кнопка)

	Если Не ЗапроситьПодтверждение() Тогда
		Возврат;
	КонецЕсли; 
	Для НомерПрохода = 1 По 2 Цикл
		Для Каждого ВыделеннаяСтрока Из ЭлементыФормы.СлужбыАгентовСерверов1С.ВыделенныеСтроки Цикл
			ДанныеСтроки = ВыделеннаяСтрока;
			Если ДанныеСтроки.ЭтоНоваяСлужба Тогда
				Продолжить;
			КонецЕсли; 
			ИмяСлужбы = ДанныеСтроки.Имя;
			Если мИмяСлужбыСобственногоАгента = ДанныеСтроки.Имя Тогда
				Если НомерПрохода = 2 Тогда 
					Сообщить("Перезапуск собственной службы на порте " + Формат(ДанныеСтроки.Порт, "ЧГ="));
					ТекстКомандногоФайла = "
					|net stop """ + ИмяСлужбы + """
					|net start """ + ИмяСлужбы + """";
					КомандныйФай = ирОбщий.СоздатьСамоудаляющийсяКомандныйФайлЛкс(ТекстКомандногоФайла);
					ЗапуститьПриложение(КомандныйФай);
				КонецЕсли; 
			Иначе
				Если НомерПрохода = 1 Тогда 
					Сообщить("Перезапуск службы на порте " + Формат(ДанныеСтроки.Порт, "ЧГ="));
					Служба = ПолучитьWMIОбъектСлужбы(ДанныеСтроки.Имя, Компьютер);
					Если Служба.State <> "Stopped" Тогда
						Если ОстановитьСлужбу(ДанныеСтроки) Тогда 
							ЖдатьСекунд = 20;
							НачальнаяДата = ТекущаяДата();
							Пока ТекущаяДата() - НачальнаяДата < ЖдатьСекунд Цикл
								ОбновитьДанные();
								СтрокиСлужбы = СлужбыАгентовСерверов1С.НайтиСтроки(Новый Структура("Имя", ИмяСлужбы));
								Если СтрокиСлужбы.Количество() = 0 Тогда
									Возврат;
								КонецЕсли;
								ДанныеСтроки = СтрокиСлужбы[0];
								ЭлементыФормы.СлужбыАгентовСерверов1С.ТекущаяСтрока = ДанныеСтроки;
								Если Не ЗначениеЗаполнено(ДанныеСтроки.ИдентификаторПроцесса) Тогда
									Прервать;
								КонецЕсли; 
							КонецЦикла;
						КонецЕсли; 
					КонецЕсли; 
					РезультатКоманды = Служба.StartService();
					Если РезультатКоманды <> 0 Тогда
						Если РезультатКоманды = 2 Тогда
							Сообщить("Недостаточно прав. Запустите приложение от имени администратора или используйте оснастку управления службами.", СтатусСообщения.Внимание);
						Иначе
							Сообщить("Код ошибки = " + РезультатКоманды + ",  https://msdn.microsoft.com/ru-ru/library/aa393660(v=vs.85).aspx", СтатусСообщения.Внимание);
						КонецЕсли; 
					КонецЕсли; 
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла;
	КонецЦикла;
	ОбновитьДанные();
	
КонецПроцедуры

Процедура ДействияФормыОстановить(Кнопка)

	Если Не ЗапроситьПодтверждение() Тогда
		Возврат;
	КонецЕсли; 
	Для Каждого ВыделеннаяСтрока Из ЭлементыФормы.СлужбыАгентовСерверов1С.ВыделенныеСтроки Цикл
		ДанныеСтроки = ВыделеннаяСтрока;
		Если ДанныеСтроки.ЭтоНоваяСлужба Тогда
			Прервать;;
		КонецЕсли; 
		Сообщить("Остановка службы на порте " + Формат(ДанныеСтроки.Порт, "ЧГ="));
		ОстановитьСлужбу(ДанныеСтроки);
	КонецЦикла;
	ОбновитьДанные();
	
КонецПроцедуры

Функция ОстановитьСлужбу(Знач ДанныеСтроки)
	
	Служба = ПолучитьWMIОбъектСлужбы(ДанныеСтроки.Имя, Компьютер);
	РезультатКоманды = Служба.StopService();
	Если РезультатКоманды <> 0 Тогда
		// Расшифровка кодов 
		Если РезультатКоманды = 2 Тогда
			Сообщить("Недостаточно прав", СтатусСообщения.Внимание);
		Иначе
			Сообщить("Код ошибки = " + РезультатКоманды + ", https://msdn.microsoft.com/ru-ru/library/aa393673(v=vs.85).aspx", СтатусСообщения.Внимание);
		КонецЕсли; 
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

Процедура ДействияФормыОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ДействияФормыСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ЭтаФорма.ОтАдминистратора = ирКэш.ВКОбщая().IsAdmin();
	ирСервер.ПолучитьПараметрыПроцессаАгентаСервера(1, 1, мИмяСлужбыСобственногоАгента);
	ОбновитьДанные();
	
КонецПроцедуры

Процедура СлужбыАгентовСерверов1СПередУдалением(Элемент, Отказ)
	
	Отказ = Не ЭлементыФормы.СлужбыАгентовСерверов1С.ТекущиеДанные.ЭтоНоваяСлужба;
	Если Отказ Тогда
		Ответ = Вопрос("Вы действительно хотите пометить службу """ + ЭлементыФормы.СлужбыАгентовСерверов1С.ТекущиеДанные.Имя + """ на удаление?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ = КодВозвратаДиалога.ОК Тогда
			ЭлементыФормы.СлужбыАгентовСерверов1С.ТекущиеДанные.Удалить = Истина;
		КонецЕсли;
	КонецЕсли; 

КонецПроцедуры

Процедура СлужбыАгентовСерверов1СПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.ЭтоНоваяСлужба = Истина;
		Элемент.ТекущиеДанные.Автозапуск = Истина;
		Элемент.ТекущиеДанные.Имя = "<Авто>";
		Элемент.ТекущиеДанные.Представление = "<Авто>";
		Элемент.ТекущиеДанные.КаталогКонфигурации = "<Авто>";
		Элемент.ТекущиеДанные.Порт = 1540;
		Элемент.ТекущиеДанные.НачальныйПортРабочихПроцессов = "<Авто>";
		Элемент.ТекущиеДанные.КонечныйПортРабочихПроцессов = "<Авто>";
		Элемент.ТекущиеДанные.РежимОтладки = "tcp";
	КонецЕсли; 

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура СлужбыАгентовСерверов1СПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.Имя = мИмяСлужбыСобственногоАгента Тогда
		ОформлениеСтроки.ЦветФона = WebЦвета.СветлоНебесноГолубой;
	КонецЕсли; 
	ОформлениеСтроки.Ячейки.ПарольПользователя.УстановитьТекст("*****");
	ОформлениеСтроки.Ячейки.СерверОтладкиПароль.УстановитьТекст("*****");
	ОформлениеСтроки.Ячейки.ГруппаСборкаПлатформы.Видимость = Ложь;
	ОформлениеСтроки.Ячейки.ГруппаПортыРабочихПроцессов.Видимость = Ложь;
	ОформлениеСтроки.Ячейки.ГруппаОтладка.Видимость = Ложь;
	
КонецПроцедуры

Процедура СлужбыАгентовСерверов1СКаталогКонфигурацииНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Если ирОбщий.ЭтоИмяЛокальногоСервераЛкс(Компьютер) Тогда
		ирОбщий.ВыбратьКаталогВФормеЛкс(ЭлементыФормы.СлужбыАгентовСерверов1С.ТекущиеДанные.КаталогКонфигурации, ЭтаФорма);
	КонецЕсли; 
	
КонецПроцедуры

Процедура СлужбыАгентовСерверов1СИмяПользователяНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФормаВыбораПользователяWindows = ирКэш.Получить().ПолучитьФорму("ВыборПользователяWindows",, ЭтаФорма);
	ФормаВыбораПользователяWindows.ВыбранныйПользовательWindows = Элемент.Значение;
	Результат = ФормаВыбораПользователяWindows.ОткрытьМодально();
	Если Результат <> Неопределено Тогда
		Элемент.Значение = Результат;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыОткрытьОснасткуУправленияСлужбами(Кнопка)
	
	ирОбщий.ПолучитьТекстРезультатаКомандыОСЛкс("services.msc",,, Истина);

КонецПроцедуры

Процедура СлужбыАгентовСерверов1ССборкаПлатформыНоваяНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	НовыйКаталог = ирОбщий.ВыбратьКаталогВФормеЛкс(Элемент.Значение);
	Если ЗначениеЗаполнено(НовыйКаталог) Тогда
		Элемент.Значение = НовыйКаталог;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыЗапуститьОтАдминистратора(Кнопка)
	
	ирОбщий.ЗапуститьСеансПодПользователемЛкс(ИмяПользователя(),,, "ОбычноеПриложение",,,,,,,, Истина);

КонецПроцедуры

Процедура СлужбыАгентовСерверов1СПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ОбновитьСтрокуЗапускаНовую(ЭлементыФормы.СлужбыАгентовСерверов1С.ТекущаяСтрока);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирУправлениеСлужбамиСерверов1С.Форма.Форма");
СписокВыбора = ЭлементыФормы.СлужбыАгентовСерверов1С.Колонки.Порт.ЭлементУправления.СписокВыбора;
#Если Сервер И Не Сервер Тогда
    СписокВыбора = Новый СписокЗначений;
#КонецЕсли
СписокВыбора.Добавить(1540);
СписокВыбора.Добавить(1640);
СписокВыбора.Добавить(1740);
СписокВыбора.Добавить(1840);
СписокВыбора.Добавить(1940);
СписокВыбора = ЭлементыФормы.СлужбыАгентовСерверов1С.Колонки.РежимОтладки.ЭлементУправления.СписокВыбора;
#Если Сервер И Не Сервер Тогда
    СписокВыбора = Новый СписокЗначений;
#КонецЕсли
СписокВыбора.Добавить("нет");
СписокВыбора.Добавить("tcp");
СписокВыбора.Добавить("http");
