﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоФизическоеЛицо = Ложь;
	
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		
		Организация = Параметры.Отбор.Владелец;
		
		УстановитьОтбор();
		
		Если Параметры.Отбор.Владелец.Метаданные().Реквизиты.Найти("ЮридическоеФизическоеЛицо") <> Неопределено Тогда
						
			РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Отбор.Владелец, "ЮридическоеФизическоеЛицо");
						
			ЭтоФизическоеЛицо = РеквизитыОрганизации.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
			
		КонецЕсли;
		
		Параметры.Отбор.Удалить("Владелец");
		
	КонецЕсли;
	
	Элементы.КПП.Видимость = НЕ ЭтоФизическоеЛицо;
	
	Элементы.Владелец.Видимость = НЕ ЗначениеЗаполнено(Организация);
	Элементы.Организация.Видимость = ЗначениеЗаполнено(Организация);
	ТолькоПросмотр = НЕ ЗначениеЗаполнено(Организация);
	
	Если Не Справочники.Организации.ИспользуетсяНесколькоОрганизаций() Тогда
		
		Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
		
		Элементы.Владелец.Видимость    = Ложь;
		Элементы.Организация.Видимость = Ложь;
		
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор()
	
	ОтборДинамическогоСписка = Список.КомпоновщикНастроек.Настройки.Отбор;
	
	ОтборДинамическогоСписка.Элементы.Очистить();
	
	ОтборВладелец = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ОтборВладелец.Использование = Истина;
	ОтборВладелец.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборВладелец.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
	ОтборВладелец.ПравоеЗначение = Организация.Ссылка;
	
	ОтборДинамическогоСписка.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
		
КонецПроцедуры
