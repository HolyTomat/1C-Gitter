﻿Перем БазоваяФорма;

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если РасположениеПанелиЗапуска <= 0 ИЛИ РасположениеПанелиЗапуска > 4 Тогда
		РасположениеПанелиЗапуска = 3;
	КонецЕсли;
	Если ОпределениеСерверногоВремени <= 0 ИЛИ ОпределениеСерверногоВремени > 3 Тогда
		ОпределениеСерверногоВремени = 1;
	КонецЕсли;
	ЭлементыФормы.ЗапускатьПриСтарте.Доступность = ирКэш.ЛиПортативныйРежимЛкс();
	Если ЭлементыФормы.ЗапускатьПриСтарте.Доступность Тогда
		ЭтаФорма.ЗапускатьПриСтарте = ОпределитьФлагЗапускаПриСтарте();
	КонецЕсли; 
	ЭтаФорма.ИмяФайлаНастроек = БазоваяФорма.ПолучитьПолноеИмяФайлаНастроек();
	ЭтаФорма.КонтекстДляОтладчика = БазоваяФорма.ПолучитьВычисляемыйКонтекстОтладчика();
	ЭтаФорма.ЛиНизкоуровневоеПолучениеОписанийОбъектов = ирКэш.Получить().ЛиНизкоуровневоеПолучениеОписанийОбъектов;
	ЭтаФорма.АвторегистрацияComКомпонент = ирКэш.Получить().АвторегистрацияComКомпонент;
	Если Не ирКэш.ЛиПортативныйРежимЛкс() Тогда
		ЭтаФорма.КаталогОбъектовДляОтладки = ирОбщий.ВосстановитьЗначениеЛкс("КаталогОбъектовДляОтладки");
	КонецЕсли; 
	ЭлементыФормы.КаталогОбъектовДляОтладки.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс();
	ЭлементыФормы.ЭмуляцияЗаписиНаСервере.Доступность = Истина
		И ирКэш.ЛиПортативныйРежимЛкс()
		И (Ложь
			Или Не ЛиСерверныйМодульДоступенЛкс(Ложь) 
			Или Не ПравоДоступа("Администрирование", Метаданные));
	Если Не ЭлементыФормы.ЭмуляцияЗаписиНаСервере.Доступность Тогда
		ЭлементыФормы.НадписьДоступностьЗаписиНаСервере.Заголовок = "Запись на сервере доступна. Эмуляция на требуется.";
	КонецЕсли; 
	//ЭлементыФормы.СписокИнструментов.ОтборСтрок.Синоним.Использование = Истина;
	ЭлементыФормы.СписокИнструментов.ОтборСтрок.Синоним.ВидСравнения = ВидСравнения.Содержит;
	
КонецПроцедуры

Процедура ОбновитьТекстОпределениеСерверногоВремени()
	
	Если ОпределениеСерверногоВремени = 1 Тогда 		
		ОпределениеСерверногоВремениСтрокой = "(Время клиента)"; 		
	ИначеЕсли ОпределениеСерверногоВремени = 2 Тогда    		
		ОпределениеСерверногоВремениСтрокой = "(Оперативная отметка времени)";  		
	ИначеЕсли ОпределениеСерверногоВремени = 3 Тогда    		
		ОпределениеСерверногоВремениСтрокой = "(Время сервера строки подключения с помощью скрипта)";  		
	КонецЕсли; 
	
КонецПроцедуры 

Процедура ОбновлениеОтображения()
	ОбновитьТекстОпределениеСерверногоВремени();
КонецПроцедуры
      
Процедура ОсновныеДействияФормыСохранитьНастройки(Кнопка = Неопределено)
	
	ирКэш.Получить().ЛиНизкоуровневоеПолучениеОписанийОбъектов = ЭтаФорма.ЛиНизкоуровневоеПолучениеОписанийОбъектов;
	ирОбщий.СохранитьЗначениеЛкс("ЛиНизкоуровневоеПолучениеОписанийОбъектов", ЭтаФорма.ЛиНизкоуровневоеПолучениеОписанийОбъектов);
	ирКэш.Получить().АвторегистрацияComКомпонент = ЭтаФорма.АвторегистрацияComКомпонент;
	ирОбщий.СохранитьЗначениеЛкс("АвторегистрацияComКомпонент", ЭтаФорма.АвторегистрацияComКомпонент);
	Если Не ирКэш.ЛиПортативныйРежимЛкс() Тогда
		ирОбщий.СохранитьЗначениеЛкс("КаталогОбъектовДляОтладки", ЭтаФорма.КаталогОбъектовДляОтладки);
	КонецЕсли; 
	БазоваяФорма.ЗаписатьНастройки();
	Если ЭлементыФормы.ЗапускатьПриСтарте.Доступность Тогда
		// запишем путь к обработке для автозапуска в файл *.v8i
		СохранитьПараметрыАвтозапуска(ЗапускатьПриСтарте);
	КонецЕсли; 
	Закрыть(Истина);
	
КонецПроцедуры
  
Процедура ОпределениеСерверногоВремениОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// запишем путь к обработке для автозапуска в файл *.v8i
Процедура СохранитьПараметрыАвтозапуска(ЗапускатьПриСтарте)
	
	// имя этого файла
	Попытка
		ИмяФайлаОбработки = ЭтотОбъект.ИспользуемоеИмяФайла;
	Исключение
		ИмяФайлаОбработки = "";
	КонецПопытки; 
	
	// получим структуру списка баз
	ДеревоСписка = ПолучитьДеревоINIFile();
	
	Если ДеревоСписка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	// определим, какая база в этом списке наша
	СтрокаСоединения = НРег(СтрокаСоединенияИнформационнойБазы());
	Отбор = Новый Структура("ЗначениеПараметра", СтрокаСоединения);
	СтрокиДерева = ДеревоСписка.Строки.НайтиСтроки(Отбор);
	Если СтрокиДерева.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	// изменим значение
	ПараметрНайден = Ложь;
	СтрокаДерева = СтрокиДерева[0];
	Для Каждого Параметр Из СтрокаДерева.Строки Цикл
		ИмяПараметра = Параметр.ИмяПараметра;
		Если ИмяПараметра <> "AdditionalParameters" Тогда
			Продолжить;
		КонецЕсли;
		Если ЗапускатьПриСтарте Тогда
			Параметр.ЗначениеПараметра = "/Execute""" + ИмяФайлаОбработки + """";
		Иначе	
			Параметр.ЗначениеПараметра = "";
		КонецЕсли;
		ПараметрНайден = Истина;
	КонецЦикла;
	
	// если параметра не было - надо добавить
	Если НЕ ПараметрНайден И ЗапускатьПриСтарте Тогда
		Параметр = СтрокаДерева.Строки.Добавить();
		Параметр.ИмяПараметра 		= "AdditionalParameters";
		Параметр.ЗначениеПараметра 	= "/Execute""" + ИмяФайлаОбработки + """";
	КонецЕсли;
	// сохраним дерево назад в файлик
	СохранитьДеревоINIFile(ДеревоСписка);
	
КонецПроцедуры	

// определение значения флага запуска при старте
Функция ОпределитьФлагЗапускаПриСтарте() 
	
	ЗначениеФлага = Ложь;
	ТекущийМодульАвтозапуска = "";
	
	// имя этого файла
	Попытка
		ИмяФайлаОбработки = ЭтотОбъект.ИспользуемоеИмяФайла;
	Исключение
		ИмяФайлаОбработки = "";
	КонецПопытки; 
	
	// получим структуру списка баз
	ДеревоСписка = ПолучитьДеревоINIFile();
	Если ДеревоСписка = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// определим, какая база в этом списке наша
	СтрокаСоединения = НРег(СтрокаСоединенияИнформационнойБазы());
	Отбор = Новый Структура("ЗначениеПараметра", СтрокаСоединения);
	СтрокиДерева = ДеревоСписка.Строки.НайтиСтроки(Отбор);
	Если СтрокиДерева.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	МаркерИР = НРег("ирПортативный.epf");
	СтрокаДерева = СтрокиДерева[0];
	Для Каждого Параметр Из СтрокаДерева.Строки Цикл
		ИмяПараметра = Параметр.ИмяПараметра;
		Если ИмяПараметра <> "AdditionalParameters" Тогда
			Продолжить;
		КонецЕсли;
		ИмяфайлаЗапуска = ирОбщий.ПолучитьСтрокуМеждуМаркерамиЛкс(Параметр.ЗначениеПараметра, "/Execute""", """");
		Если Найти(НРег(ИмяфайлаЗапуска), МаркерИР) > 0 Тогда
			ЗначениеФлага = Истина;
			ТекущийМодульАвтозапуска = ИмяфайлаЗапуска;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЗначениеФлага;
	
КонецФункции

// получение дерева из INI-файла
Функция ПолучитьДеревоINIFile()
	
	App 	= Новый COMОбъект("Shell.Application");
	AppData = App.Namespace(26).Self.Path;
	мИмяФайлаСписка = AppData+"\1C\1CEStart\ibases.v8i";
	// открываем файл в кодировке UTF8
	мФайлСписка = Новый ЧтениеТекста;
	Попытка
		мФайлСписка.Открыть(мИмяФайлаСписка, КодировкаТекста.UTF8);
	Исключение
		Сообщить("Не удалось открыть файл "+мИмяФайлаСписка);
		Возврат Неопределено;
	КонецПопытки;
	
	// подготовим результирующее дерево
	ДеревоСписка = Новый ДеревоЗначений;
	ДеревоСписка.Колонки.Добавить("ИмяПараметра");
	ДеревоСписка.Колонки.Добавить("ЗначениеПараметра");
	Разделитель 		= "=";
	СтрокаДерева		= Неопределено;
	// читаем файл
	ТекущаяСтрока = мФайлСписка.ПрочитатьСтроку();
	Пока НЕ ТекущаяСтрока = Неопределено Цикл
		
		ТекущаяСтрока = СокрЛП(ТекущаяСтрока);
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока) Тогда
			ТекущаяСтрока = мФайлСписка.ПрочитатьСтроку();
			Продолжить;
		КонецЕсли;
		ПервыйСимвол = Лев(ТекущаяСтрока,1);
		// начало раздела
		Если ПервыйСимвол = "[" Тогда
			СтрокаДерева = ДеревоСписка.Строки.Добавить();
			ИмяБазы = Сред(ТекущаяСтрока, 2);
			ИмяБазы = Лев(ИмяБазы, СтрДлина(СокрП(ИмяБазы)) - 1);
			СтрокаДерева.ИмяПараметра = ИмяБазы;
			ТекущаяСтрока = мФайлСписка.ПрочитатьСтроку();
			Продолжить;
		Иначе
			ПозицияРазделителя 	= Найти(ТекущаяСтрока,Разделитель);
			ИмяПараметра 		= Лев(ТекущаяСтрока,ПозицияРазделителя-1);
			ЗначениеПараметра 	= Сред(ТекущаяСтрока,ПозицияРазделителя+1);
			СтрокаПараметра		= СтрокаДерева.Строки.Добавить();
			СтрокаПараметра.ИмяПараметра 		= ИмяПараметра;
			СтрокаПараметра.ЗначениеПараметра 	= ЗначениеПараметра;
			
			// пропишем отдельно в таблице строку соединения базы
			Если ИмяПараметра = "Connect" Тогда
				ЗначениеПараметра = СокрЛП(ЗначениеПараметра);
				Если Прав(ЗначениеПараметра, 1) <> ";" Тогда
					ЗначениеПараметра = ЗначениеПараметра + ";";
				КонецЕсли; 
				СтрокаДерева.ЗначениеПараметра = Нрег(ЗначениеПараметра);
			КонецЕсли;
			ТекущаяСтрока = мФайлСписка.ПрочитатьСтроку();
			Продолжить;
		КонецЕсли;
	КонецЦикла;
	App = Неопределено;
	Возврат ДеревоСписка;
	
КонецФункции	

// сохранение дерева в INI-файл
Процедура СохранитьДеревоINIFile(ДеревоСписка)
	
	App 	= Новый COMОбъект("Shell.Application");
	AppData = App.Namespace(26).Self.Path;
	мИмяФайлаСписка = AppData+"\1C\1CEStart\ibases.v8i";
	// открываем файл в кодировке UTF8
	мФайлСписка = Новый ЗаписьТекста;
	Попытка
		мФайлСписка.Открыть(мИмяФайлаСписка, КодировкаТекста.UTF8);
	Исключение
		Сообщить("Не удалось открыть файл "+мИмяФайлаСписка);
		Возврат;
	КонецПопытки;
	Для Каждого СтрокаДерева Из ДеревоСписка.Строки Цикл
		СтрокаФайла = "["+СтрокаДерева.ИмяПараметра+"]";
		мФайлСписка.ЗаписатьСтроку(СтрокаФайла);
		Для Каждого Параметр Из СтрокаДерева.Строки Цикл
			СтрокаФайла = ""+Параметр.ИмяПараметра+"="+Параметр.ЗначениеПараметра;
			мФайлСписка.ЗаписатьСтроку(СтрокаФайла);
		КонецЦикла;
	КонецЦикла;
	мФайлСписка.Закрыть();
	App = Неопределено;
	
КонецПроцедуры	

// выбор како-либо обработки для открытия
Процедура ТаблицаОбъектовВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.СписокИнструментов.Колонки.Описание Тогда
		ЗапуститьПриложение("http://" + ирКэш.АдресСайтаЛкс() + "/" + ВыбраннаяСтрока.Описание);
	Иначе
		ОткрытьТекущийИнструмент();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОткрытьТекущийИнструмент()
	
	ПолноеИмя = ЭлементыФормы.СписокИнструментов.ТекущиеДанные.ПолноеИмя;
	Если ПолноеИмя <> "Разделитель" Тогда
		Если МодальныйРежим Тогда
			Ответ = Вопрос("Хотите применить изменения, закрыть форму настроек и открыть инструмент немодально?", РежимДиалогаВопрос.ДаНет);
			Если Ответ = КодВозвратаДиалога.Да Тогда
				ОсновныеДействияФормыСохранитьНастройки();
			КонецЕсли;
		КонецЕсли; 
		БазоваяФорма.ОткрытьИнструмент(ЭлементыФормы.СписокИнструментов.ТекущиеДанные);
	КонецЕсли;

КонецПроцедуры

// установить флажки
Процедура КоманднаяПанельСписокОбработокУстановитьФлажки(Кнопка)
	Для Каждого Строка Из СписокИнструментов Цикл
		Строка.Видимость = Истина;
	КонецЦикла;
КонецПроцедуры

// снять флажки
Процедура КоманднаяПанельСписокОбработокСнятьФлажки(Кнопка)
	Для Каждого Строка Из СписокИнструментов Цикл
		Строка.Видимость = Ложь;
	КонецЦикла;
КонецПроцедуры

// восстановление стандартных настроек для списка обработок
Процедура КоманднаяПанельСписокОбработокВосстановитьСтандартныеНастройки(Кнопка)
	
	БазоваяФорма.ЗаполнитьСписокИнструментовСтандартныеНастройки();
	
КонецПроцедуры

Процедура СписокИнструментовПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.ПолноеИмя = "Разделитель" Тогда
		ОформлениеСтроки.Ячейки.Видимость.ТолькоПросмотр = Истина;
		ОформлениеСтроки.Ячейки.Автозапуск.ТолькоПросмотр = Истина;
	Иначе
		Если ЗначениеЗаполнено(ДанныеСтроки.ИмяКартинки) Тогда
			ОформлениеСтроки.Ячейки.Синоним.УстановитьКартинку(ирОбщий.ПолучитьОбщуюКартинкуЛкс(ДанныеСтроки.ИмяКартинки));
		КонецЕсли; 
		Если ЗначениеЗаполнено(ДанныеСтроки.Описание) Тогда
			ОформлениеСтроки.Ячейки.Описание.УстановитьТекст("описание");
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КоманднаяПанельСписокОбработокОткрыть(Кнопка)
	
	ОткрытьТекущийИнструмент();

КонецПроцедуры

Процедура ФильтрЗначениеОчистка(Элемент, СтандартнаяОбработка)
	
	ЭлементыФормы.СписокИнструментов.ОтборСтрок.Синоним.Значение = "";
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ФильтрЗначениеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ФильтрЗначениеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ЭлементыФормы.СписокИнструментов.ОтборСтрок.Синоним.Значение) Тогда
		ЭлементыФормы.СписокИнструментов.ОтборСтрок.Синоним.Использование = Истина;
	КонецЕсли; 
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ПриОткрытии()
	
	ЭлементыФормы.НадписьКлиентСерверногоЗапуска.Видимость = Истина
		И ирКэш.ЛиПортативныйРежимЛкс()
		И Не ирКэш.ЭтоФайловаяБазаЛкс()
		И Не ирОбщий.ЭтоИмяЛокальногоСервераЛкс(ирОбщий.ИмяКомпьютераКластераЛкс())
		И Лев(ЭтотОбъект.ИспользуемоеИмяФайла, 2) <> "\\";
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);

КонецПроцедуры

Процедура КоманднаяПанельСписокОбработокПоискПоТекстамИнтерфейса(Кнопка)
	
	Форма = ирКэш.Получить().ПолучитьФорму("СтруктураФормы",, "ВсеИнструменты");
	Форма.Открыть();
	
КонецПроцедуры

Процедура КаталогОбъектовДляОтладкиНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ВыбратьКаталогВФормеЛкс(КаталогОбъектовДляОтладки, ЭтаФорма, "Выберите каталог объектов для отладки");
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПортативный.Форма.ФормаНастроек");
БазоваяФорма = ирОбщий.ПолучитьФормуЛкс("Обработка.ирПортативный.Форма.Форма");

// Антибаг платформы. Очищаются свойство данные, если оно указывает на отбор табличной части
ЭлементыФормы.ФильтрЗначение.Данные = "ЭлементыФормы.СписокИнструментов.Отбор.Синоним.Значение";
ЭлементыФормы.ФильтрЗначение.КнопкаВыбора = Ложь;
ЭлементыФормы.ФильтрЗначение.КнопкаСпискаВыбора = Истина;
ЭлементыФормы.ФильтрИспользование.Данные = "ЭлементыФормы.СписокИнструментов.Отбор.Синоним.Использование"
