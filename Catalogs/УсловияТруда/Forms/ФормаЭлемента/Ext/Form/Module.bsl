﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Первоначальное заполнение объекта.
	Если Параметры.Ключ.Пустая() Тогда
		
		СсылкаНаОбъект = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка).ПолучитьСсылку();
		ПриПолученииДанныхНаСервере(Объект.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОтредактированаИстория" И Параметр.ИмяРегистра = "КлассыУсловийТрудаПоДолжностям" Тогда
		Если КлассыУсловийТрудаПоДолжностямНаборЗаписейПрочитан Тогда
			РедактированиеПериодическихСведенийКлиент.ОбработкаОповещения(ЭтаФорма, СсылкаНаОбъект, ИмяСобытия, Параметр, Источник);
			ОбновитьПолеКлассыУсловийТрудаПоДолжностямПериод(ЭтаФорма);
		КонецЕсли;
	КонецЕсли;
	
	ТекстПодсказкиКПоляДатаРегистрации = УчетСтраховыхВзносовКлиентСервер.ТекстПодсказкиПоляДатаРегистрацииПериодическихРегистров();
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		"КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзменений", 
		"Подсказка", 
		ТекстПодсказкиКПоляДатаРегистрации);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	СсылкаНаОбъект = ТекущийОбъект.Ссылка;
	ПриПолученииДанныхНаСервере(ТекущийОбъект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Параметры.Ключ.Пустая() Тогда
		ТекущийОбъект.УстановитьСсылкуНового(СсылкаНаОбъект);
	КонецЕсли;
	
	РедактированиеПериодическихСведений.ЗаписатьЗаписьПослеРедактированияВФорме(ЭтаФорма, "КлассыУсловийТрудаПоДолжностям", СсылкаНаОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	РедактированиеПериодическихСведений.ПроверитьЗаписьВФорме(ЭтаФорма, "КлассыУсловийТрудаПоДолжностям", СсылкаНаОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВзимаютсяВзносыЗаЗанятыхНаРаботахСДосрочнойПенсиейФлажокПриИзменении(Элемент)
	
	Если НЕ ВзимаютсяВзносыЗаЗанятыхНаРаботахСДосрочнойПенсией Тогда
		Объект.ВзимаютсяВзносыЗаЗанятыхНаРаботахСДосрочнойПенсией = ПредопределенноеЗначение("Перечисление.ВидыРаботСДосрочнойПенсией.ПустаяСсылка");
	КонецЕсли;
	УстановитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямКлассУсловийТрудаПриИзменении(Элемент)
	РедактированиеПериодическихСведенийКлиентСервер.ОбновитьОтображениеПолейВвода(ЭтаФорма, "КлассыУсловийТрудаПоДолжностям", СсылкаНаОбъект);
	УстановитьДатуРегистрацииКлассаУсловийТрудаПоПериоду();
	ОбновитьПолеКлассыУсловийТрудаПоДолжностямДатаРегистрацииИзменений(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	Оповещение = Новый ОписаниеОповещения("КлассыУсловийТрудаПоДолжностямПериодНачалоВыбораЗавершение", ЭтотОбъект);
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(
		ЭтаФорма,
		ЭтаФорма,
		"КлассыУсловийТрудаПоДолжностямПериод",
		"КлассыУсловийТрудаПоДолжностямПериодСтрокой", ,
		Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямПериодНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт 
	
	КлассыУсловийТрудаПоДолжностям.Период = КлассыУсловийТрудаПоДолжностямПериод;
	
	УстановитьДатуРегистрацииКлассаУсловийТрудаПоПериоду();
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)

	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(
		ЭтаФорма,
		"КлассыУсловийТрудаПоДолжностямПериод",
		"КлассыУсловийТрудаПоДолжностямПериодСтрокой",
		Направление,
		Модифицированность);

	КлассыУсловийТрудаПоДолжностям.Период = КлассыУсловийТрудаПоДолжностямПериод;
	
	УстановитьДатуРегистрацииКлассаУсловийТрудаПоПериоду();
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямПериодАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)

	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямПериодОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)

	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямПериодПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(
		ЭтаФорма,
		"КлассыУсловийТрудаПоДолжностямПериод",
		"КлассыУсловийТрудаПоДолжностямПериодСтрокой",
		Модифицированность);

	КлассыУсловийТрудаПоДолжностям.Период = КлассыУсловийТрудаПоДолжностямПериод;
	
	УстановитьДатуРегистрацииКлассаУсловийТрудаПоПериоду();
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(
		ЭтаФорма,
		"КлассыУсловийТрудаПоДолжностям.ДатаРегистрацииИзменений",
		"КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийСтрокой",
		Модифицированность);	
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(
		ЭтаФорма,
		ЭтаФорма,
		"КлассыУсловийТрудаПоДолжностям.ДатаРегистрацииИзменений",
		"КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(
		ЭтаФорма,
		"КлассыУсловийТрудаПоДолжностям.ДатаРегистрацииИзменений",
		"КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийСтрокой",
		Направление,
		Модифицированность);

КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ВыплачиваетсяНадбавкаЗаВредностьПриИзменении(Элемент)
	
	УстановитьОтображениеПроцентаНадбавкиЗаВредность(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КлассУсловийТрудаИстория(Команда)
	РедактированиеПериодическихСведенийКлиент.ОткрытьИсторию("КлассыУсловийТрудаПоДолжностям", СсылкаНаОбъект, ЭтаФорма, ТолькоПросмотр);
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПрочитатьКлассыУсловийТрудаПоДолжностям()
	
	РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(ЭтаФорма, "КлассыУсловийТрудаПоДолжностям", СсылкаНаОбъект);
	ОбновитьПолеКлассыУсловийТрудаПоДолжностямПериод(ЭтаФорма);
	
	ОбновитьПолеКлассыУсловийТрудаПоДолжностямДатаРегистрацииИзменений(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПолеКлассыУсловийТрудаПоДолжностямДатаРегистрацииИзменений(Форма)	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Форма, "КлассыУсловийТрудаПоДолжностям.ДатаРегистрацииИзменений", "КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийСтрокой");
	
	Форма.Элементы.КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзменений.АвтоОтметкаНезаполненного = Форма.Элементы.КлассыУсловийТрудаПоДолжностямПериод.АвтоОтметкаНезаполненного;
	
	Если Не Форма.Элементы.КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзменений.АвтоОтметкаНезаполненного
		И Не ЗначениеЗаполнено(Форма.КлассыУсловийТрудаПоДолжностям.Период) Тогда
		
		Форма.Элементы.КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзменений.ОтметкаНезаполненного = Ложь;
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПолеКлассыУсловийТрудаПоДолжностямПериод(Форма)
	
	РедактированиеПериодическихСведенийКлиентСервер.ОбновитьОтображениеПолейВвода(Форма, "КлассыУсловийТрудаПоДолжностям", Форма.СсылкаНаОбъект);
	Форма.КлассыУсловийТрудаПоДолжностямПериод = Форма.КлассыУсловийТрудаПоДолжностям.Период;
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Форма, "КлассыУсловийТрудаПоДолжностямПериод", "КлассыУсловийТрудаПоДолжностямПериодСтрокой");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементов(Форма)
	
	Форма.Элементы.ВзимаютсяВзносыЗаЗанятыхНаРаботахСДосрочнойПенсией.Доступность = Форма.ВзимаютсяВзносыЗаЗанятыхНаРаботахСДосрочнойПенсией;
	УстановитьОтображениеПроцентаНадбавкиЗаВредность(Форма);
	
КонецПроцедуры	

&НаСервере
Процедура ПриПолученииДанныхНаСервере(СсылкаНаОбъект)
	
	ВзимаютсяВзносыЗаЗанятыхНаРаботахСДосрочнойПенсией = ЗначениеЗаполнено(Объект.ВзимаютсяВзносыЗаЗанятыхНаРаботахСДосрочнойПенсией);
	
	ПрочитатьКлассыУсловийТрудаПоДолжностям();
	УстановитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры
	
&НаКлиенте
Процедура УстановитьДатуРегистрацииКлассаУсловийТрудаПоПериоду()
	
	КлассыУсловийТрудаПоДолжностям.ДатаРегистрацииИзменений = НачалоМесяца(КлассыУсловийТрудаПоДолжностям.Период);	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтотОбъект, "КлассыУсловийТрудаПоДолжностям.ДатаРегистрацииИзменений", "КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийСтрокой");
	
КонецПроцедуры	

&НаСервере
Процедура ПрочитатьНаборЗаписейПериодическихСведений(ИмяРегистра, ВедущийОбъект) Экспорт
	
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(ЭтаФорма, ИмяРегистра, ВедущийОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеПроцентаНадбавкиЗаВредность(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ПроцентНадбавкиЗаВредность",
		"Доступность",
		Форма.Объект.ВыплачиваетсяНадбавкаЗаВредность);
	
КонецПроцедуры

#КонецОбласти
