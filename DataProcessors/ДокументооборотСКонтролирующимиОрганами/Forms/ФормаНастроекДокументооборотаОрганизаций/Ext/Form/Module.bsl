﻿&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидНастроек = Параметры.ВидНастроек;
	
	ТекстЗапроса = "";
	
	Если НЕ ЗначениеЗаполнено(ВидНастроек) Тогда
		
		ЭтаФорма.Заголовок = "Настройки обмена с ФНС, ПФР и Росстатом";
		ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	ВЫБОР
		               |		КОГДА Организации.ПометкаУдаления ИЛИ Организации.УчетнаяЗаписьОбмена.ПометкаУдаления
		               |			ТОГДА 4
		               |		ИНАЧЕ 3
		               |	КОНЕЦ КАК ПометкаУдаления,
		               |	Организации.Ссылка КАК Организация,
		               |	ВЫБОР
		               |		КОГДА Организации.ВидОбменаСКонтролирующимиОрганами = ЗНАЧЕНИЕ(Перечисление.ВидыОбменаСКонтролирующимиОрганами.ОбменВУниверсальномФормате)

		               |			ТОГДА ""Обмен в универсальном формате""
		               |		ИНАЧЕ ВЫБОР
		               |				КОГДА Организации.ВидОбменаСКонтролирующимиОрганами = ЗНАЧЕНИЕ(Перечисление.ВидыОбменаСКонтролирующимиОрганами.ОбменЧерезСпринтер)

		               |					ТОГДА ""Обмен посредством ПК """"Спринтер""""""
		               |				ИНАЧЕ ""Не используется""
		               |			КОНЕЦ
		               |	КОНЕЦ КАК ВидОбменаСКонтролирующимиОрганами
		               |ИЗ
		               |	Справочник.Организации КАК Организации";
		
	ИначеЕсли ВидНастроек = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСС") Тогда
		
		ЭтаФорма.Заголовок = "Настройки обмена с ФСС";
		ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	ВЫБОР
		               |		КОГДА Организации.ПометкаУдаления
		               |			ТОГДА 4
		               |		ИНАЧЕ 3
		               |	КОНЕЦ КАК ПометкаУдаления,
		               |	Организации.Ссылка КАК Организация,
		               |	ВЫБОР
		               |		КОГДА ЕСТЬNULL(НастройкиОбменаФСС.ИспользоватьОбмен, ЛОЖЬ)
		               |			ТОГДА ""Используется""
		               |		ИНАЧЕ ""Не используется""
		               |	КОНЕЦ КАК ВидОбменаСКонтролирующимиОрганами
		               |ИЗ
		               |	Справочник.Организации КАК Организации
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиОбменаФСС КАК НастройкиОбменаФСС
		               |		ПО (НастройкиОбменаФСС.Организация = Организации.Ссылка)";
		
	ИначеЕсли ВидНастроек = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСРАР") Тогда
					   
		ЭтаФорма.Заголовок = "Настройки обмена с ФСРАР";
		ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	ВЫБОР
		               |		КОГДА Организации.ПометкаУдаления
		               |			ТОГДА 4
		               |		ИНАЧЕ 3
		               |	КОНЕЦ КАК ПометкаУдаления,
		               |	Организации.Ссылка КАК Организация,
		               |	ВЫБОР
		               |		КОГДА ЕСТЬNULL(НастройкиОбменаФСРАР.ИспользоватьОбмен, ЛОЖЬ)
		               |			ТОГДА ""Используется""
		               |		ИНАЧЕ ""Не используется""
		               |	КОНЕЦ КАК ВидОбменаСКонтролирующимиОрганами
		               |ИЗ
		               |	Справочник.Организации КАК Организации
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиОбменаФСРАР КАК НастройкиОбменаФСРАР
		               |		ПО (НастройкиОбменаФСРАР.Организация = Организации.Ссылка)";
		
	ИначеЕсли ВидНастроек = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.РПН") Тогда
		
		ЭтаФорма.Заголовок = "Настройки обмена с РПН";
		ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	ВЫБОР
		               |		КОГДА Организации.ПометкаУдаления
		               |			ТОГДА 4
		               |		ИНАЧЕ 3
		               |	КОНЕЦ КАК ПометкаУдаления,
		               |	Организации.Ссылка КАК Организация,
		               |	ВЫБОР
		               |		КОГДА ЕСТЬNULL(НастройкиОбменаРПН.ИспользоватьОбмен, ЛОЖЬ)
		               |			ТОГДА ""Используется""
		               |		ИНАЧЕ ""Не используется""
		               |	КОНЕЦ КАК ВидОбменаСКонтролирующимиОрганами
		               |ИЗ
		               |	Справочник.Организации КАК Организации
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиОбменаРПН КАК НастройкиОбменаРПН
		               |		ПО (НастройкиОбменаРПН.Организация = Организации.Ссылка)";
		
	ИначеЕсли ВидНастроек = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФТС") Тогда
		
		ЭтаФорма.Заголовок = "Настройки обмена с ФТС";
		ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	ВЫБОР
		               |		КОГДА Организации.ПометкаУдаления
		               |			ТОГДА 4
		               |		ИНАЧЕ 3
		               |	КОНЕЦ КАК ПометкаУдаления,
		               |	Организации.Ссылка КАК Организация,
		               |	ВЫБОР
		               |		КОГДА ЕСТЬNULL(НастройкиОбменаФТС.ИспользоватьОбмен, ЛОЖЬ)
		               |			ТОГДА ""Используется""
		               |		ИНАЧЕ ""Не используется""
		               |	КОНЕЦ КАК ВидОбменаСКонтролирующимиОрганами
		               |ИЗ
		               |	Справочник.Организации КАК Организации
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиОбменаФТС КАК НастройкиОбменаФТС
		               |		ПО (НастройкиОбменаФТС.Организация = Организации.Ссылка)";
					   
	ИначеЕсли ВидНастроек = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.БанкРоссии") Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("РегламентированнаяОтчетность.ЭлектронныйДокументооборотСКонтролирующимиОрганами.СдачаОтчетностиВБанкРоссии") Тогда
			МодульДокументооборотСБанкомРоссии = ОбщегоНазначения.ОбщийМодуль("ДокументооборотСБанкомРоссии");
			
			ЭтаФорма.Заголовок = "Настройки обмена с Банком России";
			ТекстЗапроса = МодульДокументооборотСБанкомРоссии.ПолучитьТекстЗапросаДляФормыНастроек();
		КонецЕсли;
		
	КонецЕсли;
	
	СписокНастроек.ТекстЗапроса 				= ТекстЗапроса;
	СписокНастроек.ДинамическоеСчитываниеДанных = Истина;
	СписокНастроек.ОсновнаяТаблица 				= "Справочник.Организации";
	
	Элементы.СписокНастроекОрганизацияУчетнаяЗаписьОбмена.Видимость = 
		ДокументооборотСКОВызовСервера.ИспользуетсяРежимТестирования();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеНастроекЭДООрганизации" Тогда
		Элементы.СписокНастроек.Обновить();
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокНастроекПередНачаломИзменения(Элемент, Отказ)
	
	ОткрытьФормуНастройки();
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокНастроекПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНастроекПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНастроекВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНастроекПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ОткрытьФормуНастройки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьНастройку(Команда)
	
	ОткрытьФормуНастройки();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастройки()
	
	ТекущиеДанные = Элементы.СписокНастроек.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Выберите организацию'"));
		Возврат;
	КонецЕсли;
	
	Организация = ТекущиеДанные.Организация;
	
	Если НЕ ЗначениеЗаполнено(ВидНастроек) Тогда
		
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсФНСиПФРиРосстатом(Организация);
					   
	ИначеЕсли ВидНастроек = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСС") Тогда
		
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсФСС(Организация);
	   
	ИначеЕсли ВидНастроек = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСРАР") Тогда
		
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсФСРАР(Организация);
		
	ИначеЕсли ВидНастроек = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.РПН") Тогда
		
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсРПН(Организация);
		
	ИначеЕсли ВидНастроек = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФТС") Тогда
		
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсФТС(Организация);
		
	ИначеЕсли ВидНастроек = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.БанкРоссии") Тогда
		
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсБанкомРоссии(Организация);
	
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти



