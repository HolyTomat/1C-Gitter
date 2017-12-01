﻿
Процедура ОсновныеДействияФормыОК(Кнопка)
	
	НовоеЗначение = ПолучитьРезультат();
	ирОбщий.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, НовоеЗначение);
	
КонецПроцедуры

Функция ПолучитьРезультат()
	
	Возврат Новый ХранилищеЗначения(Значение);

КонецФункции

Процедура ПриОткрытии()
	
	Если ТипЗнч(НачальноеЗначениеВыбора) <> Тип("ХранилищеЗначения") Тогда
		НачальноеЗначениеВыбора = Новый ХранилищеЗначения(Неопределено);
	КонецЕсли; 
	Значение = НачальноеЗначениеВыбора.Получить();
	ЗначениеПриИзменении();
	ЭлементыФормы.Значение.ТипЗначения = ирОбщий.ОписаниеТиповВсеРедактируемыеТипыЛкс();
	ЭлементыФормы.Значение.Значение = Значение;

КонецПроцедуры

Процедура ОсновныеДействияФормыИсследовать(Кнопка)
	
	ирОбщий.ИсследоватьЛкс(ПолучитьРезультат());
	
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ЗначениеПриИзменении(Элемент = Неопределено)
	
	Если Элемент <> Неопределено Тогда
		ЭтаФорма.Значение = ЭлементыФормы.Значение.Значение;
	КонецЕсли; 
	ЭтаФорма.ТипЗначения = ТипЗнч(Значение);
	
КонецПроцедуры

Процедура ЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаРасширенногоЗначения_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка, Значение);
	ЗначениеПриИзменении();
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ХранилищеЗначения");

