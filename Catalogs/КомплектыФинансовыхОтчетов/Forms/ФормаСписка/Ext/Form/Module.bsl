﻿
&НаКлиенте
Перем ПараметрыОбработчикаОжидания;
&НаКлиенте
Перем ФормаДлительнойОперации;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	ОбновитьДатуЗапретаОтраженияНаСервере();
	ИдентификаторФормыДлительнойОперации = Новый УникальныйИдентификатор;
	
	ВидПериода = Перечисления.ДоступныеПериодыОтчета.Год;
	НачалоПериода = НачалоГода(ТекущаяДатаСеанса());
	КонецПериода = КонецГода(ТекущаяДатаСеанса());
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокВидовОтчетов.Отбор, "КомплектОтчетности", 0, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокЭкземпляров.Отбор, "ВидОтчета", 0, ВидСравненияКомпоновкиДанных.Равно,, Истина);

	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ТонкийКлиент ИЛИ ВебКлиент Тогда
		Элементы.КнопкаСравнитьЭкземпляры.Заголовок = НСтр("ru = 'Сравнить экземпляры (Толстый клиент)'");
		Элементы.КнопкаСравнитьЭкземпляры.Доступность = Ложь;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененаДатаЗапретаФормированияПроводок" Тогда
		ОбновитьДатуЗапретаОтраженияНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатусКомплектаОтчетностиПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокКомплектов.Отбор, "Статус", СтатусКомплектаОтчетности, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(СтатусКомплектаОтчетности));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийСпискаКомплектов

&НаКлиенте
Процедура СписокКомплектовПриАктивизацииСтроки(Элемент)
	
	ЭтаФорма.ПодключитьОбработчикОжидания("СписокКомплектовПриАктивизацииСтрокиОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийСпискаВидовОтчетов

&НаКлиенте
Процедура СписокВидовОтчетовПриАктивизацииСтроки(Элемент)
	
	ЭтаФорма.ПодключитьОбработчикОжидания("СписокВидовОтчетовПриАктивизацииСтрокиОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийСпискаЭкземпляров

&НаКлиенте
Процедура СписокЭкземпляровПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ТекущийВидОтчета = Элементы.СписокВидовОтчетов.ТекущаяСтрока;
	Если ТекущийВидОтчета <> Неопределено Тогда
		СформироватьОтчеты(ТекущийВидОтчета);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЭкземпляровПриАктивизацииСтроки(Элемент)
	
	#Если НЕ ТонкийКлиент И НЕ ВебКлиент Тогда
	Элементы.КнопкаСравнитьЭкземпляры.Доступность = Элементы.СписокЭкземпляров.ВыделенныеСтроки.Количество() > 1;
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПереместитьЭлементВверх(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВверхВыполнить(СписокКомплектов, Элементы.СписокКомплектов);
	
КонецПроцедуры // ПереместитьЭлементВверх()

&НаКлиенте
Процедура ПереместитьЭлементВниз(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВнизВыполнить(СписокКомплектов, Элементы.СписокКомплектов);
	
КонецПроцедуры // ПереместитьЭлементВниз()

&НаКлиенте
Процедура ВидОтчетовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("Ключ", ВыбраннаяСтрока);
	ПараметрыФормы.Вставить("КомплектОтчетности", Элементы.СписокКомплектов.ТекущиеДанные.Ссылка);
	ОткрытьФорму("Справочник.ВидыФинансовыхОтчетов.Форма.ФормаЭлемента",ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьКомплект(Команда)
	
	ТекущийКомплект = Элементы.СписокКомплектов.ТекущаяСтрока;
	Если ТекущийКомплект <> Неопределено Тогда
		СформироватьОтчеты(ТекущийКомплект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СравнитьЭкземпляры(Команда)
	
	#Если ТонкийКлиент ИЛИ ВебКлиент Тогда
		ТекстВопроса = НСтр("ru='Сравнение средствами 1С:Предприятия возможно только в толстом клиенте.'");
		ПоказатьПредупреждение(Неопределено, ТекстВопроса);
		Возврат;
	#КонецЕсли
	
	#Если НЕ ТонкийКлиент И НЕ ВебКлиент Тогда
		ФайлыСравнения = Новый Массив;
		Для Индекс = 0 По 1 Цикл
			Экземпляр = Элементы.СписокЭкземпляров.ВыделенныеСтроки[Индекс];
			ХранилищеРезультата = ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(Экземпляр,"РезультатОтчета");
			РезультатОтчета = ХранилищеРезультата.Получить();
			Если РезультатОтчета = Неопределено Тогда
				Возврат;
			КонецЕсли;
			ПолноеИмяФайла = ПолучитьИмяВременногоФайла("mxl");
			ФайлыСравнения.Добавить(ПолноеИмяФайла);
			РезультатОтчета.Записать(ПолноеИмяФайла);
		КонецЦикла;
		
		Если ФайлыСравнения <> Неопределено Тогда
			Сравнение = Новый СравнениеФайлов;
			Сравнение.СпособСравнения = СпособСравненияФайлов.ТабличныйДокумент;
			Сравнение.ПервыйФайл = ФайлыСравнения[0];
			Сравнение.ВторойФайл = ФайлыСравнения[1];
			Сравнение.ПоказатьРазличия();
			
			Попытка
				Для Каждого ПолноеИмяФала Из ФайлыСравнения Цикл
					УдалитьФайлы(ПолноеИмяФала);
				КонецЦикла;
			Исключение
			КонецПопытки;
			
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДатуЗапрета(Команда)
	
	ОткрытьФорму("РегистрСведений.ДатыЗапретаФормированияПроводокМеждународныйУчет.Форма.ДатыЗапретаФормирования", , ЭтаФорма);
	
КонецПроцедуры

#Область ОбработчикиОжидания

&НаКлиенте
Процедура СписокКомплектовПриАктивизацииСтрокиОбработчикОжидания()
	
	ТекущийКомплект = Элементы.СписокКомплектов.ТекущаяСтрока;
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокВидовОтчетов.Отбор, "КомплектОтчетности", ТекущийКомплект, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
	ТекущийВидОтчета = Элементы.СписокВидовОтчетов.ТекущаяСтрока;
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокЭкземпляров.Отбор, "КомплектОтчетности", ТекущийКомплект, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокЭкземпляров.Отбор, "ВидОтчета", ТекущийВидОтчета, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВидовОтчетовПриАктивизацииСтрокиОбработчикОжидания()
	
	ТекущийВидОтчета = Элементы.СписокВидовОтчетов.ТекущаяСтрока;
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокЭкземпляров.Отбор, "ВидОтчета", ТекущийВидОтчета, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НачалоПериодаДействия.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОкончаниеПериодаДействия.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЭкземплярыОтчетов.НачалоПериода");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЭкземплярыОтчетов.ОкончаниеПериода");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Формат", "Л=ru; ДЛФ=D");

КонецПроцедуры

#Область Прочее

&НаКлиенте
Функция СформироватьОтчеты(НаборОтчетов)
	
	ПараметрыЭкземпляров = МеждународнаяОтчетностьКлиентСервер.НовыеПараметрыФормированияОтчета();
	ПараметрыЭкземпляров.Вставить("Ресурс", "Сумма");
	ПараметрыЭкземпляров.ФлагОткрытьФормы = ТипЗнч(НаборОтчетов) = Тип("СправочникСсылка.КомплектыФинансовыхОтчетов");
	ЗаполнитьЗначенияСвойств(ПараметрыЭкземпляров, ЭтаФорма);
	ПараметрыФормы = Новый Структура("ПараметрыЭкземпляров", ПараметрыЭкземпляров);
	ГенераторОтчета = Новый ОписаниеОповещения("СформироватьЭкземплярыОтчетов", ЭтаФорма, НаборОтчетов);
	ОткрытьФорму("Справочник.КомплектыФинансовыхОтчетов.Форма.ФормаПараметровОтчета", ПараметрыФормы, ЭтаФорма,,,,ГенераторОтчета);
	
КонецФункции

&НаКлиенте
Процедура СформироватьЭкземплярыОтчетов(ПараметрыЭкземпляров, НаборОтчетов) Экспорт
	
	Если ПараметрыЭкземпляров = Неопределено
		ИЛИ ПараметрыЭкземпляров = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ПараметрыЭкземпляров);
	ИдентификаторЗадания = Новый УникальныйИдентификатор;
	ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	
	Если НЕ ИБФайловая Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
	КонецЕсли;
	
	ПодготовитьДанныеЭкземпляров(НаборОтчетов);
	
	Если ИБФайловая Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	Элементы.СписокЭкземпляров.Обновить();
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьДанныеЭкземпляров(НаборОтчетов)

	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);

	ИдентификаторЗадания = Неопределено;

	ПараметрыЭкземпляров = ПодготовитьПараметрыЭкземпляров(НаборОтчетов);
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		МеждународнаяОтчетностьСервер.СформироватьКомплектОтчетов(ПараметрыЭкземпляров, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		ИмяПроцедуры = "МеждународнаяОтчетностьСервер.СформироватьКомплектОтчетов";
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			ИмяПроцедуры,
			ПараметрыЭкземпляров,
			"ФормированиеКомплектаОтчетовМеждународнойФинансовойОтчетности");

		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПодготовитьПараметрыЭкземпляров(НаборОтчетов)
	
	Если ТипЗнч(НаборОтчетов) = Тип("СправочникСсылка.КомплектыФинансовыхОтчетов") Тогда
		ВидыОтчетов = НаборОтчетов.ВидыОтчетов.ВыгрузитьКолонку("ВидФинансовогоОтчета");
	Иначе
		ВидыОтчетов = Новый Массив;
		ВидыОтчетов.Добавить(НаборОтчетов);
	КонецЕсли;
	
	ТекущийКомплект = Элементы.СписокКомплектов.ТекущаяСтрока;
	ПараметрыЭкземпляров = Новый Структура;
	ПараметрыЭкземпляров.Вставить("ИдентификаторГлавногоХранилища", УникальныйИдентификатор);
	ПараметрыЭкземпляров.Вставить("КомплектОтчетности", ТекущийКомплект);
	ПараметрыЭкземпляров.Вставить("ВидыОтчетов", ВидыОтчетов);
	ПараметрыЭкземпляров.Вставить("НаборОтчетов", НаборОтчетов);
	
	ЭкземплярыОтчетов = Новый Соответствие;
	Для Каждого ВидОтчета Из ВидыОтчетов Цикл
		Адрес = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		ЭкземплярыОтчетов.Вставить(ВидОтчета, Адрес);
	КонецЦикла;
	ПараметрыЭкземпляров.Вставить("ЭкземплярыОтчетов", ЭкземплярыОтчетов);
	
	ПериодОтчета = Новый Структура("НачалоПериода, КонецПериода");
	ПериодОтчета.НачалоПериода = НачалоПериода;
	ПериодОтчета.КонецПериода = КонецПериода;
	ПараметрыЭкземпляров.Вставить("ПериодОтчета", ПериодОтчета);
	
	Отбор = Новый Структура;
	Отбор.Вставить("Организация", Организация);
	Отбор.Вставить("Подразделение", Подразделение);
	Отбор.Вставить("НаправлениеДеятельности", НаправлениеДеятельности);
	ПараметрыЭкземпляров.Вставить("Отбор", Отбор);
	
	ПараметрыЭкземпляров.Вставить("ВидОтчета", Неопределено);
	ПараметрыЭкземпляров.Вставить("РезультатОтчета", Неопределено);
	ПараметрыЭкземпляров.Вставить("Ресурс", Ресурс);
	ПараметрыЭкземпляров.Вставить("ВыводитьКодСтроки", Ложь);
	ПараметрыЭкземпляров.Вставить("ВыводитьПримечание", Ложь);
	ПараметрыЭкземпляров.Вставить("СуммыВТысячах", СуммыВТысячах);
	ПараметрыЭкземпляров.Вставить("ОткрытьФормы", ОткрытьФормы);
	
	Возврат ПараметрыЭкземпляров;
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьПодготовленныеДанные()
	
	ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(РезультатВыполнения.НаборОтчетов) = Тип("СправочникСсылка.ВидыФинансовыхОтчетов")
		ИЛИ РезультатВыполнения.ОткрытьФормы Тогда
		ПараметрыФормы = Новый Структура("Ключ");
		
		Для Каждого Экземпляр Из РезультатВыполнения.ДанныеЭкземпляров Цикл
			ПараметрыФормы = Новый Структура("АдресХранилища, СформироватьОтчет", Экземпляр.Ключ, Ложь);
			ПараметрыФормы.Вставить("ПользовательскиеНастройки", Экземпляр.Значение);
			ОткрытьФорму("Отчет.МеждународныйОтчет.Форма.ФормаОтчета", ПараметрыФормы, ЭтаФорма, Истина);
		КонецЦикла;
		
	КонецЕсли;
	
	ИдентификаторЗадания = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()

	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ЗагрузитьПодготовленныеДанные();
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания",
				ПараметрыОбработчикаОжидания.ТекущийИнтервал,
				Истина);
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура СписокКомплектовПриИзменении(Элемент)
	
	Элементы.СписокВидовОтчетов.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДатуЗапретаОтраженияНаСервере()
	
	ДатаЗапрета = МеждународныйУчетСерверПовтИсп.ДатаЗапретаФормированияПроводок();
	Элементы.УстановитьДатуЗапрета.Заголовок = МеждународныйУчетОбщегоНазначения.ПредставлениеКомандыУстановитьДатуЗапрета(ДатаЗапрета);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
